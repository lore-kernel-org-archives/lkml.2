Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab0HSAUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 20:20:10 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:43964 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0HSAUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 20:20:08 -0400
Date: Thu, 19 Aug 2010 02:20:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] scripts/mkversion: Simplify script
Message-ID: <20100819002006.GA13637@merkur.ravnborg.org>
References: <1282165945-27195-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282165945-27195-1-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 02:42:25AM +0530, Ramkumar Ramachandra wrote:
> Simplify the script and add a line to help editors recognize this as a
> shell script.

This does not IMO simplify the script.
The original version is simple to follow for the usual C coder.
The new version is harder to follow.

Adding the bangshee (#!/bin/sh) is fine.

	Sam
