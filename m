Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab0GEU3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 16:29:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62722 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab0GEU3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 16:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w65L45ziarUTNJRx8xtnI5vNHX4vQnbAhYUGtZBPEY7jD7bBLYk0IMOyxf9K2sruQq
         +FlJWdapiyHgQlxTi8tCW0FjUaMruwh5KIHf5LThCjqoOigRXcL2N+SaeEKYNVetMPzp
         ia4lPxpU62dHKvs3fpmG2sFLujnbi861tv2Bo=
Date: Mon, 5 Jul 2010 13:29:11 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: feng.tang@intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@elte.hu, jacob.jun.pan@intel.com, randy.dunlap@oracle.com
Subject: Re: [PATCH v2 0/5] patches to settle i8042 with Intel MID platforms
Message-ID: <20100705202911.GC17013@core.coreip.homeip.net>
References: <1278342202-10973-1-git-send-email-feng.tang@intel.com>
 <4C32364D.2040705@zytor.com>
 <20100705202221.GA16978@core.coreip.homeip.net>
 <4C323F6A.6080102@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C323F6A.6080102@zytor.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 01:24:10PM -0700, H. Peter Anvin wrote:
> On 07/05/2010 01:22 PM, Dmitry Torokhov wrote:
> > 
> > Looks hood to me as well. We can either merge it through my tree or x86
> > tree, I don't have a preference.
> > 
> 
> OK if I merge it then with your Acked-by:?
> 

Certainly.

-- 
Dmitry
