Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab0C2GiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 02:38:06 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:47860 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0C2GiE convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Mon, 29 Mar 2010 02:38:04 -0400
Message-Id: <4BB066E7020000780003766B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 29 Mar 2010 07:37:59 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: <teheo@suse.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] free_early_partial() should permit start == end
References: <4BACF0E60200007800037373@vpn.id2.novell.com>
 <4BAD1B72.9040002@kernel.org>
In-Reply-To: <4BAD1B72.9040002@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Yinghai Lu <yinghai@kernel.org> 26.03.10 21:39 >>>
>can you check if this patch work for you?

I'm sure it works, too. But I find it less clean to add special case handling
instead of just getting the original code right.

Jan

