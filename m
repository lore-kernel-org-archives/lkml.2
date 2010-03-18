Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab0CRQuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:50:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab0CRQuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:50:37 -0400
Date: Thu, 18 Mar 2010 17:49:55 +0100
From: Veaceslav Falico <vfalico@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] signal_struct->count must die, initial changes
Message-ID: <20100318164955.GA19611@darkmag.usersys.redhat.com>
References: <20100317192847.GA2086@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100317192847.GA2086@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 08:28:47PM +0100, Oleg Nesterov wrote:
> signal_struct->count in its current form must die.

Ack on this series.
Acked-by: Veaceslav Falico <vfalico@redhat.com>

--
Veaceslav
