Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab0J0Uuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:50:50 -0400
Received: from thunk.org ([69.25.196.29]:51740 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab0J0Uur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:50:47 -0400
Date: Wed, 27 Oct 2010 16:50:43 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix unbalanced mutex unlock
Message-ID: <20101027205043.GG3194@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Nicolas Kaiser <nikai@nikai.net>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20101026011534.0bb7cb64@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101026011534.0bb7cb64@absol.kitzblitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 01:15:34AM +0200, Nicolas Kaiser wrote:
> Although the mutex isn't locked yet, if ext4_li_request_new
> fails, the mutex would get unlocked on the error path.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

Nice catch, thanks!!  I've applied a fix to the ext4 patch queue.

     	    	      	   	   - Ted
