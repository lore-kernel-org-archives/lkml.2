Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab1DLGYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 02:24:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34746 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab1DLGYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 02:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oXZ4ks2hw3rF0+RSsqZw2T8e6ks+3eD174AdiU/qOjJb3d8rQPSpOz/GclRgHeZGcO
         3dwZTZodZCtPHsWd3DkMi/eaKq0EuKdfDDZvApY4612R8CteZK3IryPgxDVQvmRVpkso
         o0yNi+QnPS4cvn+JeiCH1u0K8czjRBP68E0Lk=
Date: Mon, 11 Apr 2011 23:24:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: wanlong.gao@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INPUT:Change a more clearly name for the input handlers'
 table
Message-ID: <20110412062416.GE1854@core.coreip.homeip.net>
References: <1302265424-4434-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302265424-4434-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 08:23:44PM +0800, wanlong.gao@gmail.com wrote:
> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> Change the input handlers' table name to input_handler_table for
> making more clearly sense .
> 

Sorry but I think the old name is fine. I'd rather see this table
removed altogether and character devices pushed down into input handlers
themselves.

Thanks.

-- 
Dmitry
