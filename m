Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab2HBNjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:39:45 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:36756 "EHLO
	homiemail-a94.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754332Ab2HBNjo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:39:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=references
	:in-reply-to:mime-version:content-transfer-encoding:content-type
	:message-id:cc:from:subject:date:to; q=dns; s=shealevy.com; b=Dr
	Vfy1MLtgDKisumckgstVaCGmu8QjGA+ZjdBPNfOBOGA2IvPJGsas8EfXrkg2injJ
	RZU9oJWbbHStVduKn0H8J6GB4a3UGp4AZLNcpvpPwmZcYorGgW3uzCyyjISvWcXM
	HCvVSb75uiFStlBJarwc4rzUnHGurE7zI1E3S03eg=
References: <1343911533-3423-1-git-send-email-shea@shealevy.com> <CANq1E4Tn6nugb0vmMb1VzTE+-io0bV2y7OLaEXtXbav4W51Kag@mail.gmail.com>
In-Reply-To: <CANq1E4Tn6nugb0vmMb1VzTE+-io0bV2y7OLaEXtXbav4W51Kag@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <65B6AB74-5658-49F1-BB6F-5A644CC10098@shealevy.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPad Mail (9B206)
From: Shea Levy <shea@shealevy.com>
Subject: Re: [PATCH] Bluetooth: Add support for Apple MacBook Pro 9,2
Date: Thu, 2 Aug 2012 09:39:44 -0400
To: David Herrmann <dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Aug 2, 2012, at 9:32 AM, David Herrmann <dh.herrmann@googlemail.com> wrote:

> Hi Shea
> 
> On Thu, Aug 2, 2012 at 2:45 PM,  <shea@shealevy.com> wrote:
>> From: Shea Levy <shea@shealevy.com>
>> 
>> 
>> Signed-off-by: Shea Levy <shea@shealevy.com>
> 
> Why is this patch missing a commit-message? Please add one.

The commit message was only one line, which git-send-email puts in the subject.

> And also
> include the output of "usb-devices" or the contents of
> /sys/kernel/debug/usb/devices in this commit-message.
> 

OK. The whole thing or just the relevant bits? Does it matter if I'm booted into the patched kernel or not?

Thanks,
Shea