Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1E3Afb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 20:35:31 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55643 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1E3Afa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 20:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fc/lF9aqUipz8Y3YxbnpnrTR1Gn39Q+fG3PBZsjbZUFB4XRs5Zr9k65qNXdP5LFxsg
         +0rbI4X82Oo8QDcri0yXaAdHzaZYWM+Whrhe8kYzrZlWwkKByl2q2bCmouTwZ8UTMLGH
         ooHTsnIO5o4Y5XWoCYbATJsI+qB/1hmaXlMug=
MIME-Version: 1.0
In-Reply-To: <1306701498-10846-1-git-send-email-cesarb@cesarb.net>
References: <1306701498-10846-1-git-send-email-cesarb@cesarb.net>
Date: Mon, 30 May 2011 09:35:29 +0900
Message-ID: <BANLkTikX+dKsdwGOxG10Q2LVd_rCxEBRHw@mail.gmail.com>
Subject: Re: [PATCH] cleancache: use __read_mostly for cleancache_enabled
From: Minchan Kim <minchan.kim@gmail.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, Jan Beulich <JBeulich@novell.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger@sun.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 5:38 AM, Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> The global variable cleancache_enabled is read often but written to
> rarely. Use __read_mostly to prevent it being on the same cacheline as
> another variable which is written to often, which would cause cacheline
> bouncing.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
