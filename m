Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab0LGKl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:41:27 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56105 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab0LGKlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:41:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PNZ5poMUtGZQsLamdTaT1Gkx6L3ftBmDJoqB1iAW1dq6oON3YNO/Q3KLuPWJ9QnwoN
         PbAbd5NfCOounTCv2uPm5BCznB/JixOpNUhHNTsXlrKf5kj624r942gVkl/g2IKwLWu3
         HZJz/821ZFu1La05VyHZGjs/HJPZqgESrqENQ=
Date: Tue, 7 Dec 2010 02:41:18 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Add hovering distance axis
Message-ID: <20101207104118.GB2817@core.coreip.homeip.net>
References: <1291710468-2022-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291710468-2022-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 09:27:48AM +0100, Henrik Rydberg wrote:
> Touch devices capable of hovering, i.e., fingers detected a distance
> from the surface, are not supported by the current input MT
> protocol. This patch adds ABS_MT_DISTANCE, which may be used to
> indicate the distance between the contact and the surface.
> 

Makes sense.

Thanks.

-- 
Dmitry
