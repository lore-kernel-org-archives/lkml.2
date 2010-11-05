Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab0KEMwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 08:52:23 -0400
Received: from THUNK.ORG ([69.25.196.29]:53179 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab0KEMwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 08:52:20 -0400
Date: Fri, 5 Nov 2010 08:52:11 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?Q?Andr=E9?= Luis Pereira dos Santos -
	 BSRSoft <andre@bsrsoft.com.br>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] fs: Small refactoring of the code in ext4
 2.6.37-rc1
Message-ID: <20101105125211.GH7553@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	=?iso-8859-1?Q?Andr=E9?= Luis Pereira dos Santos - BSRSoft <andre@bsrsoft.com.br>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <756314.4122.qm@web110514.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <756314.4122.qm@web110514.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 04:34:26PM -0700, André Luis Pereira dos Santos - BSRSoft wrote:
> 
> I had not realized that the side effect would really be changing
> variables incremented and decremented.

You're also wrong if you think that "i--" is more efficient than "i =
i - 1".  Any good compiler will do the right thing with either
expression.

       	    	     	       	    	      - Ted
