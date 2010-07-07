Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab0GGWMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 18:12:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab0GGWMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 18:12:41 -0400
Date: Wed, 7 Jul 2010 16:12:45 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: usblp: fixed switch, brace, whitespace and spacing
 coding style issues
Message-ID: <20100707161245.5241119e@lembas.zaitcev.lan>
In-Reply-To: <20100625202537.1cd4526c@absol.kitzblitz>
References: <20100625202537.1cd4526c@absol.kitzblitz>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010 20:25:37 +0200
Nicolas Kaiser <nikai@nikai.net> wrote:

> Fixed switch, brace, whitespace and spacing coding style issues.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

I'm fine with this. The double-indented switches definitely needed
to go for a long time, but I'm too conservative. The rest is the
price of switches, I guess.

-- Pete
