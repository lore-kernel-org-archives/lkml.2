Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030391Ab2CBQe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 11:34:57 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61140 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842Ab2CBQez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 11:34:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of yhlu.kernel@gmail.com designates 10.236.155.6 as permitted sender) smtp.mail=yhlu.kernel@gmail.com; dkim=pass header.i=yhlu.kernel@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F50ABD1.7000402@mvista.com>
References: <1330629843-6027-1-git-send-email-yinghai@kernel.org>
	<4F50ABD1.7000402@mvista.com>
Date: Fri, 2 Mar 2012 08:34:55 -0800
X-Google-Sender-Auth: oMbDR9M_cXlgDHlnXrwZiO90T18
Message-ID: <CAE9FiQUPY_-GKt9KCUPPr-qarqDKL-VQ2ZdXs8OR1Fv68JFAEg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] usb, PCI: split quirk for usb host controller to four
From: Yinghai Lu <yinghai@kernel.org>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-usb@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 3:15 AM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
>
> On 01-03-2012 23:24, Yinghai Lu wrote:
>
>> so we avoid checking class again and again in that quirk.
>
>
>> following patches will remove disable/enable for non-xhci
>> and nelogic vendor checking for uhci/xhci
>
>
>   Why add them in the first place?
>

never mind, just drop those patches, sarah had some different view and
want to keep disable/enable
device for all usb host controller instead of only xhci.

Thanks

       Yinghai
