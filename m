Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab0GWSf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:35:58 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65089 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab0GWSf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:35:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lvQeGJmGql/bTnHuLbD1AW4gtrxRPhMI2/uKeVmkMBf1Ftdkuo8v1gRh+nw483Ltyx
         9DBVK1Jcbm99JBBodJN31QM727HVM9XBZx8rmkqaqfdFF+POCxmJOcL8ACj31URfKCCO
         GKMs4rRnfgS04pFlDpkZVD2sX72vTvUhEXg3c=
Date: Fri, 23 Jul 2010 21:35:49 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Davidlohr Bueso <dave.bueso@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] [PATCH procfs] Add process age
Message-ID: <20100723183549.GA10518@x200>
References: <1279907271.4335.3.camel@cowboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279907271.4335.3.camel@cowboy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 01:47:51PM -0400, Davidlohr Bueso wrote:
> This patch exports a process's age, in seconds, adding a /proc/#/age file.

What for?
