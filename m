Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab0LMTrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:47:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230Ab0LMTrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:47:02 -0500
Date: Mon, 13 Dec 2010 14:46:52 -0500
From: David Teigland <teigland@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] dlm: sanitize work_start() in lowcomms.c
Message-ID: <20101213194652.GD30360@redhat.com>
References: <1292254105-3952-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292254105-3952-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 12:28:25AM +0900, Namhyung Kim wrote:
> The create_workqueue() returns NULL if failed rather than ERR_PTR().
> Fix error checking and remove unnecessary variable 'error'.

I adapted this to the alloc_workqueue patch in next and pushed to next.
Dave

