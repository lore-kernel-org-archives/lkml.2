Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab0FKGbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:31:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57014 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab0FKGa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:30:59 -0400
Date: Fri, 11 Jun 2010 08:30:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org
Subject: Re: [PATCH]script:conf.c Fix warning: variable 'type' set but not
	used
Message-ID: <20100611063056.GD6864@basil.fritz.box>
References: <1276233832-17193-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276233832-17193-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I get this using gcc 4.6.0 the below change fixes this form me.
> (not sure with earlier version of gcc).
> please have a look and let me know.

>From a quick look it's likely correct, but you really need
to send this to the Kconfig maintainer, not to me.

-Andi
