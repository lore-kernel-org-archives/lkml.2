Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab0EMHkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:40:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40767 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab0EMHkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:40:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=opchHjERjNLXY3+8BeOh2oqFOMdXnFZpJOiUpPIomXidkeAKCC1+KVWiX4ilvTFg9h
         v7po1VwsmG+tK5BJw8KQUzihVj7RvvlWPgoV7Ds74VEJ8X/0o+dKtPluA/lZPT8S1CjX
         PYyEZsbq13HPanbOjnY+zdAUvf3KkLDJ1N1Q0=
Date: Thu, 13 May 2010 00:40:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC tip/core/rcu 17/23] input: __rcu annotations
Message-ID: <20100513074006.GA30110@core.coreip.homeip.net>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
 <1273700022-16523-17-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273700022-16523-17-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 02:33:36PM -0700, Paul E. McKenney wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Dmitry Torokhov <dtor@mail.ru>

Please merge with the rest of RCU annotations.

-- 
Dmitry
