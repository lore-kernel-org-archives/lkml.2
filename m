Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab1LKQ7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 11:59:21 -0500
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:64628 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab1LKQ7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 11:59:20 -0500
Message-ID: <4EE4E152.2070204@udo.edu>
Date: Sun, 11 Dec 2011 17:58:58 +0100
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111120 Thunderbird/8.0
MIME-Version: 1.0
To: Udo Steinberg <udo@hypervisor.org>
CC: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: iwlagn regression in v3.1.5
References: <4EE4AEF4.2080702@udo.edu> <4EE4DB55.4090804@udo.edu> <20111211174138.79e51fe8@x220.fritz.box>
In-Reply-To: <20111211174138.79e51fe8@x220.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is pretty mean regression for the stable kernel. You may the fix 
only for cards, which need it and not for all of them.

Regards,
Andrej

On 12/11/2011 05:41 PM, Udo Steinberg wrote:
> Hi,
>
> The patch fixes the following bug:
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2326
>
> If the patch introduces a regression for you, then the problem needs to be
> investigated further. Reverting the patch will reintroduce an already fixed
> problem for others.
>
> Cheers,
>
> 	- Udo
>
