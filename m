Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab1KGSYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:24:46 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59248 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932999Ab1KGSYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:24:44 -0500
X-Sasl-enc: 7OOoIkijOuXUgZ5mAs8mXRx+aZItZ4KW+MHcNvHN7Ofi 1320690283
Date: Mon, 7 Nov 2011 10:24:39 -0800
From: Greg KH <greg@kroah.com>
To: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Namhyung Kim <namhyung@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: mm: avoid null pointer access in vm_struct via /proc/vmallocinfo
Message-ID: <20111107182439.GA5806@kroah.com>
References: <20111102191929.GA13061@kroah.com>
 <4EB7D7F7.4090807@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB7D7F7.4090807@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 10:07:03PM +0900, HAYASAKA Mitsuo wrote:
> Hi Greg,
> 
> > So, if someone wants this patch there, could they please provide me with
> > a backported version?
> 
> I'd like to send the patch for backport version.

Please do.
