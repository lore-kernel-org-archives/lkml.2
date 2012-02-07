Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab2BGNaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:30:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59486 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2BGNaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:30:10 -0500
Message-ID: <4F31275A.8000502@lwfinger.net>
Date: Tue, 07 Feb 2012 07:30:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Richard Farina <sidhayn@gmail.com>
CC: sarah.a.sharp@linux.intel.com, andiry.xu@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: Question about error from xhci-hcd
References: <4F30BB0B.5060203@gmail.com>
In-Reply-To: <4F30BB0B.5060203@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 11:47 PM, Richard Farina wrote:
> I apologize but I am having the same issue reported in this thread in
> December
>
> [ 5077.573181] xhci_hcd 0000:0a:00.0: ERROR no room on ep ring
>
> I saw no resolution on this issue so I figured I'd step up and see if
> you needed an active tester who could reproduce the issue.
>
> I am running Gentoo with a 3.2.2 kernel.  I am able to run any kernel
> version you need, including random git trees and custom patches.  If you
> have not solved this yet, please allow me to be your test monkey. If you
> have solved this already then sorry for harming the signal to noise
> ratio, I could not a find a later message then the one below.

Are the "no room" messages triggered by rtl8192cu, or some other driver?

Larry


