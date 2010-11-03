Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0KCO6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 10:58:24 -0400
Received: from ifup.org ([198.145.64.140]:48915 "EHLO ifup.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab0KCO6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 10:58:22 -0400
Date: Wed, 3 Nov 2010 07:57:13 -0700
From: Brandon Philips <brandon@ifup.org>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] staging: ft1000: Get rid of BOOLEAN typedef usage.
Message-ID: <20101103145713.GA2000@jenkins.mit.edu>
References: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
 <1288779595-15793-7-git-send-email-marek.belisko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288779595-15793-7-git-send-email-marek.belisko@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:19 Wed 03 Nov 2010, Marek Belisko wrote:
> -   BOOLEAN                 bGoodVersion;
> +   u8                 bGoodVersion;

Please use the bool type instead of u8. Might as well do FALSE/TRUE ->
false/true while you are at it :)

Cheers,

	Brandon
