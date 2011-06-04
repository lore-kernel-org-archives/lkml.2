Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab1FDFyX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 01:54:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54141 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1FDFyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 01:54:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-message-flag
         :x-operating-system:x-editor:x-disclaimer:user-agent;
        b=q44t1WU66KHiMLavGzi01UKkh2/mV0H1p0U555mxmx1X+23kBGtVSDcuaXImoFH+If
         4mRsoi+9xarQhYHUdTpBXX+fY+TWsHGWRHAmF+VCVKJK9iiGbPVqmMVbz6W7rRVn6vJy
         Pj+8tGKdPLMKispd+wuUm0FrXAwIR4OmCbMC8=
Date: Sat, 4 Jun 2011 14:54:28 +0900
From: Mattia Dongili <malattia@linux.it>
To: Greg Dietsche <gregory.dietsche@cuw.edu>
Cc: mjg@redhat.com, kernel-janitors@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sony-laptop: remove unused local variables
Message-ID: <20110604055427.GA2901@kamineko.org>
References: <1307068040-2918-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <4DE84AE8.60109@cuw.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE84AE8.60109@cuw.edu>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.39+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 09:46:00PM -0500, Greg Dietsche wrote:
> please disregard... i neglected to rebase before sending. this patch
> no longer applies to the mainline.

the same patch was also already sent by Guenter Roeck a few days ago:
http://www.spinics.net/lists/platform-driver-x86/msg02018.html

thanks
-- 
mattia
:wq!
