Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0LOH5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 02:57:51 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:49684 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab0LOH5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 02:57:50 -0500
Message-ID: <4D0874FB.8080503@telenet.be>
Date: Wed, 15 Dec 2010 08:57:47 +0100
From: Jef Driesen <jefdriesen@telenet.be>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Robert Lukassen <Robert.Lukassen@tomtom.com>
CC: Greg KH <greg@kroah.com>, David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: g_serial: Allow to override the default VID/PID
References: <4CE6F807.1090607@telenet.be> <1290209554-7026-1-git-send-email-jefdriesen@telenet.be> <20101120001247.GB17421@kroah.com> <4CE853BF.80504@telenet.be> <D6DB9C7EDECDA944B870F62B587008622C8A42@NL-EXC-06.intra.local> <20101130174605.GC19977@kroah.com> <4CF96A9D.8070800@telenet.be> <D6DB9C7EDECDA944B870F62B587008622C8A4D@NL-EXC-06.intra.local>
In-Reply-To: <D6DB9C7EDECDA944B870F62B587008622C8A4D@NL-EXC-06.intra.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/10 09:09, Robert Lukassen wrote:
> Yes, providing access to those module parameters was the original goal. I
> agree that my patch should be reverted and I'll try to come up with a method
> of accessing these values without violating the information hiding principles
> too much. I don't like accessing globals.

Do I have to take any action to make sure the original commit [1] gets reverted?

[1] 1ab83238740ff1e1773d5c13ecac43c60cf4aec4
