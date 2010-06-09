Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab0FIWg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:36:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38112 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab0FIWgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bde1i94Q1yB4hGlhJ4JLDPvo2MXqKpGw9fDRnYTKzcPz7rXy0nJUZM5OBi1omAa2Dy
         QaIJyObDXHA5V2jNsAC4ZnViY/QPX2/jx/Sg7zE0m+DnzMeIfngcS3QnM6XuO82oGSPF
         wul0A9/uyOyC3H3to67NGFpmm9OyKWdw1xNH8=
Date: Thu, 10 Jun 2010 00:36:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 02/13] jump label v9: base patch
Message-ID: <20100609223652.GC12752@nowhere>
References: <cover.1276116186.git.jbaron@redhat.com> <ba56ef382c3b1a1d17a21005d5c4eda54cced0bf.1276116186.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba56ef382c3b1a1d17a21005d5c4eda54cced0bf.1276116186.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 05:38:57PM -0400, Jason Baron wrote:
> +#define JUMP_TABLE()							\
> +	. = ALIGN(64);							\
> +		VMLINUX_SYMBOL(__start___jump_table) = .;		\
> +		*(__jump_table)						\
> +		VMLINUX_SYMBOL(__stop___jump_table) = .;		\
> +



Why does it need to be aligned to 64?

Thanks.

