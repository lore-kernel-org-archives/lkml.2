Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966317Ab0GQMal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 08:30:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42782 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab0GQMaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 08:30:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wqqRfoDttpxTR96P+qhcOf0Oft82yAdXELKWJsHKjx9rlHX4amRTLYIhQhidlUgJTo
         p3kMto2+x+zt7TwBC8i72F08yJG9+tBPCwxBk5Dh50CeowW+aK/OWsKLjyFmjvJeoynP
         oD+zyUR0b82typNdBCRXwhHeWh625RSSbA68Y=
Subject: Re: [PATCH] timers.c: document meaning of deferrable timer
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Neil Brown <neilb@suse.de>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Venki Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <20100706171908.GL7387@fieldses.org>
References: <1277996756-8415-1-git-send-email-dedekind1@gmail.com>
	 <20100706171908.GL7387@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Jul 2010 15:30:32 +0300
Message-Id: <1279369832.7515.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-06 at 13:19 -0400, J. Bruce Fields wrote:
> From: J. Bruce Fields <bfields@citi.umich.edu>
> 
> Steal some text from 6e453a67510 "Add support for deferrable timers".
> A reader shouldn't have to dig through the git logs for the basic
> description of a deferrable timer.
> 
> Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>

Yes, this is a good idea. Someone cares to pick this?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

