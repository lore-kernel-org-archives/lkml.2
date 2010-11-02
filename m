Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0KBDdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 23:33:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46648 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab0KBDdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 23:33:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kQ8Ui7Yae+Cb3WXeAmKjx6ubOS4Z/6zqSFfDx9sLAuUV8kF0vL034ajLNSASa/W1Hr
         7l5vnLglxK7JSTyWZSpQ==
Date: Mon, 1 Nov 2010 20:33:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ben Gamari <bgamari.foss@gmail.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] Add Kconfig option for default swappiness
In-Reply-To: <1288668052-32036-1-git-send-email-bgamari.foss@gmail.com>
Message-ID: <alpine.DEB.2.00.1011012030100.12298@chino.kir.corp.google.com>
References: <1288668052-32036-1-git-send-email-bgamari.foss@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, Ben Gamari wrote:

> This will allow distributions to tune this important vm parameter in a more
> self-contained manner.
> 

And they can't use an init script to tune /proc/sys/vm/swappiness 
because...?
