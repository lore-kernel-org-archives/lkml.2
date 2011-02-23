Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab1BWN5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:57:08 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42620 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1BWN5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:57:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=POKeveC7Wxgb/6Rs3lnmyX0uRWxiB9vD3AtDLjoYXJvLarbrBzhcWHpHwfXCCkXeo3
         AmcTFpfqEBb+Gr4DNDWbdTpr6sVzHWr5Q+QhxZuI4H74seDXmecwzLqhIl1PbFf6nsk1
         fKXRFxy4UCSt8ne022jy+exgIS/fTY8QqOG84=
Date: Wed, 23 Feb 2011 16:56:32 +0300
From: Dan Carpenter <error27@gmail.com>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: martyn.welch@ge.com, devel@driverdev.osuosl.org, gregkh@suse.de,
        cota@braap.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: vme: remove unreachable code
Message-ID: <20110223135632.GA19898@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Manohar Vanga <manohar.vanga@cern.ch>, martyn.welch@ge.com,
	devel@driverdev.osuosl.org, gregkh@suse.de, cota@braap.org,
	linux-kernel@vger.kernel.org
References: <1298467528-26472-1-git-send-email-manohar.vanga@cern.ch>
 <1298467528-26472-2-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298467528-26472-2-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 02:25:27PM +0100, Manohar Vanga wrote:
> Removed some unreachable code from vme_register_bridge
> 
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

Acked-by: Dan Carpenter <error27@gmail.com>


