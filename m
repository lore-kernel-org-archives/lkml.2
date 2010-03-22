Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab0CVNuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:50:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab0CVNuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:50:20 -0400
Date: Mon, 22 Mar 2010 08:50:11 -0500
From: David Teigland <teigland@redhat.com>
To: Dan Carpenter <error27@gmail.com>,
       Christine Caulfield <ccaulfie@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] dlm: cleanup remove unused code
Message-ID: <20100322135011.GA29680@redhat.com>
References: <20100322120354.GB21571@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322120354.GB21571@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 03:03:54PM +0300, Dan Carpenter wrote:
> Smatch complains because "lkb" is never NULL.  Looking at it, the original
> code actually adds the new element to the end of the list fine, so we can
> just get rid of the if condition.  This code is four years old and no one
> has complained so it must work.

Thanks, queued for the next pull.
Dave

