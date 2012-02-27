Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab2B0Nyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 08:54:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab2B0Nyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 08:54:35 -0500
Date: Mon, 27 Feb 2012 08:54:28 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Andrei Warkentin <andrey.warkentin@gmail.com>
Cc: dm-devel@redhat.com, andreiw@vmware.com, linux-kernel@vger.kernel.org
Subject: Re: DM: Minor fix to dm-snap metadata backend registration.
Message-ID: <20120227135427.GC9784@redhat.com>
References: <1330136812-4377-1-git-send-email-andrey.warkentin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330136812-4377-1-git-send-email-andrey.warkentin@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24 2012 at  9:26pm -0500,
Andrei Warkentin <andrey.warkentin@gmail.com> wrote:

> Cleanup in dm_exception_store_init was messed up.
> 
> Signed-off-by: Andrei Warkentin <andrey.warkentin@gmail.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>
