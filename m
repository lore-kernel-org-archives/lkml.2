Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0I2Qjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 12:39:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58274 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab0I2Qjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 12:39:32 -0400
MIME-Version: 1.0
In-Reply-To: <20100929162625.GB17087@fieldses.org>
References: <20100929162625.GB17087@fieldses.org>
Date: Wed, 29 Sep 2010 09:39:30 -0700
Message-ID: <AANLkTin2E2ACB5yiAUA7MbYqzYyMKAi+syFOCzXWqVrY@mail.gmail.com>
Subject: Re: null dereference in ipip6_get_stats in linux-next
From: Jesse Gross <jesse@nicira.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 9:26 AM, J. Bruce Fields <bfields@fieldses.org> wrote:
> Last night's linux-next fails to boot for me; apologies if this is already
> known.

Eric sent out a patch for this:
http://patchwork.ozlabs.org/patch/65961/
