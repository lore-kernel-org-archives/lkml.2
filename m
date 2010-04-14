Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab0DNQEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:04:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59198 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab0DNQEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:04:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Pphcul4hHDRky/ERaXLI7b4NjLkJ9Iq4bha7CXZNYjJTGneT0AvWR/hLrlCOOH9Yv9
         nnxCtzVdrzfH22YBYCJNRSoDcROcWN1OpmAJL3y8EJ2zJbwIvXw22+huHhd29LfGXEdF
         tFJsJ969+omcxfTMMu5ir8n1eQvGCJeaxloxg=
Date: Wed, 14 Apr 2010 09:04:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: add HP Compaq 2710p to 'noloop' table
Message-ID: <20100414160429.GC2450@core.coreip.homeip.net>
References: <alpine.LNX.2.00.1004141409450.8345@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1004141409450.8345@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Wed, Apr 14, 2010 at 02:16:25PM +0200, Jiri Kosina wrote:
> Add HP Compaq 2710p to 'noloop' table. Otherwsie this machine is reported 
> to not report properly to AUX_LOOP command time-to-time, causing 
> non-working keyboard due to messed up i8042.
> 

What is the chassis type for the box in DMI? I am curious why it isn't
caought up by the generic "portable" test...

Thanks.

-- 
Dmitry
