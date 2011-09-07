Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab1IGX1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 19:27:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab1IGX1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 19:27:38 -0400
Date: Wed, 7 Sep 2011 16:27:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, konrad.wilk@oracle.com,
        JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk,
        riel@redhat.com, hannes@cmpxchg.org, matthew@wil.cx,
        chris.mason@oracle.com, sjenning@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, jackdachef@gmail.com,
        cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: Re: [PATCH V8 3/4] mm: frontswap: add swap hooks and extend
 try_to_unuse
Message-Id: <20110907162703.7f8116b9.akpm@linux-foundation.org>
In-Reply-To: <20110829164929.GA27216@ca-server1.us.oracle.com>
References: <20110829164929.GA27216@ca-server1.us.oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011 09:49:29 -0700
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> -static int try_to_unuse(unsigned int type)
> +int try_to_unuse(unsigned int type, bool frontswap,

Are patches 2 and 3 in the wrong order?
