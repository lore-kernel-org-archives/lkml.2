Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab1BWN6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:58:16 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64770 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab1BWN6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:58:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=kxrPr+4JISuGmlnCp32WmTzbwKXaTDE8me/m/2T1HGjBtmudB1KjjwcQzHn3GcxzFY
         7NaIBQFheuhIyiw5p2E86uP/TpNor6Nw3lMVHfUvC3G+tfLLRnzrSM0kG2/iozKxN5t9
         hEHEFFJBqGyK6XsxL0OfPD8B/b6hAvBVsiXH8=
Date: Wed, 23 Feb 2011 16:57:45 +0300
From: Dan Carpenter <error27@gmail.com>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: martyn.welch@ge.com, devel@driverdev.osuosl.org, gregkh@suse.de,
        cota@braap.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: vme: fix loop condition
Message-ID: <20110223135745.GB19898@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Manohar Vanga <manohar.vanga@cern.ch>, martyn.welch@ge.com,
	devel@driverdev.osuosl.org, gregkh@suse.de, cota@braap.org,
	linux-kernel@vger.kernel.org
References: <1298467528-26472-1-git-send-email-manohar.vanga@cern.ch>
 <1298467528-26472-3-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298467528-26472-3-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 02:25:28PM +0100, Manohar Vanga wrote:
> Fix loop condition in vme_register_bridge that results in an infinite
> loop in the event that device_register fails.
> 

Acked-by: Dan Carpenter <error27@gmail.com>

