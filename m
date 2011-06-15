Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1FOVvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:51:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:38100 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab1FOVvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:51:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ta5L5ubu9vlg4youfgrvj+cbyIP+E5Mf769HKkT42LQK8MNMECrPRBNBw3JHNUphCS
         NNvnjYvrSojvW02rSs7ycQ03n+jV2jzIgs9xZgo6gaOvLcj7fv6Ntuu2NaO0QFGITTcD
         RUcjO6KGXSOa+e/HcW9Zq1ggYXFO0AgDQdr8I=
MIME-Version: 1.0
In-Reply-To: <BANLkTik03b2CWwfVpN3atNfVZbDe=Wz3qw@mail.gmail.com>
References: <BANLkTik03b2CWwfVpN3atNfVZbDe=Wz3qw@mail.gmail.com>
Date: Wed, 15 Jun 2011 18:50:57 -0300
Message-ID: <BANLkTinvpmn6fMBDNq_GxOhWW6W5XDErXQ@mail.gmail.com>
Subject: Re: PROBLEM: unable to enumerate USB device on port 6 (3 kernel test)
From: =?ISO-8859-1?Q?Franco_Gast=F3n_Pellegrini?= 
	<francogpellegrini@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Wed, 15 Jun 2011 21:51:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi again,

when i use the following workaround, the messeges stop spamming ttys
and usb keep working fine, Why? is hardware or kernel problem? (i know
a lot of people with the same problem):

Workaround:
Edit /etc/rc.local

Insert the following:

cd /sys/bus/pci/drivers/ehci_hcd
for i in `ls -d 0000:00:*`;do echo $i > unbind;sleep 5; echo $i > bind; done




2011/5/13 Franco Gastón Pellegrini <francogpellegrini@gmail.com>:
> I tested the kernels:
>
> 2.6.38-8-generic
> 2.6.39-0-generic (kernel-ppa/ppa)
>
> In all I have the same problem, except 2.6.35 and earlier versions,
> where no error occurs.
>
> I inform you that on my laptop is connected only integrated SD card
> reader (ACER 5520 with nForce 610M mother).
>
>
> ---------- Forwarded message ----------
> From: Franco Gastón Pellegrini <francogpellegrini@gmail.com>
> Date: 2011/5/3
> Subject: PROBLEM: unable to enumerate USB device on port 6
> To: linux-kernel@vger.kernel.org
>
>
> Kernel version: 2.6.38-8-generic #42-Ubuntu SMP Mon Apr 11 03:31:24
> UTC 2011 x86_64 x86_64 x86_64 GNU/Linux
>
> hi,
> I have an ACER 5520, with ubuntu 11.04 and all my TTY repeats
> indefinitly (every 1/3 seconds) the mesages:
>
> .....
> May 1 18:34:27 franco-Aspire-5520 kernel: [ 888.350128] hub 1-0:1.0:
> unable to enumerate USB device on port 6
> May 1 18:34:27 franco-Aspire-5520 kernel: [ 888.610230] hub 3-0:1.0:
> unable to enumerate USB device on port 6
> May 1 18:34:27 franco-Aspire-5520 kernel: [ 888.890098] hub 1-0:1.0:
> unable to enumerate USB device on port 6
> May 1 18:34:28 franco-Aspire-5520 kernel: [ 889.150111] hub 3-0:1.0:
> unable to enumerate USB device on port 6
> ....
>
> i cant use any TTY, how can i fix it? any kernel before do this for me.
>
> PD: what info do you need to complete my report?
>
> Excuse my english
>
