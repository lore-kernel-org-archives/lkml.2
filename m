Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab1KPNH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:07:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:38126 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab1KPNHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:07:25 -0500
Subject: Re: [PATCH] sched: add the inline keyword to the prototype.
From: Peter Zijlstra <peterz@infradead.org>
To: Il Han <corone.il.han@gmail.com>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1321447504-4477-1-git-send-email-corone.il.han@gmail.com>
References: <1321447504-4477-1-git-send-email-corone.il.han@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Nov 2011 14:06:50 +0100
Message-ID: <1321448810.1421.78.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3- 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 21:45 +0900, Il Han wrote:
> The prototype has to agree with the definition.
> Add the inline keyword to the prototype also.

Is this something gcc-4.6 wants or so? I guess I should go build new
compilers, again.
