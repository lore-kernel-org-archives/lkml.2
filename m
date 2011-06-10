Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab1FJQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 12:09:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:52571 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1FJQJ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 12:09:57 -0400
Subject: Re: BUG on 3.0-rc on commit
 d72bce0e67e8afc6eb959f656013cbb577426f1e
From: Peter Zijlstra <peterz@infradead.org>
To: habanero@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, rostedt <rostedt@goodmis.org>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1307718797.17297.2.camel@atheurer-w510>
References: <1307711837.23688.33.camel@atheurer-ubuntu10>
	 <1307715084.3941.166.camel@twins>  <1307718797.17297.2.camel@atheurer-w510>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Jun 2011 18:09:44 +0200
Message-ID: <1307722184.3941.177.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 10:13 -0500, Andrew Theurer wrote:
> > happen to have a .config handy?
> 
> attached. 

Just my luck, my machine boots fine until the root mount fails (which I
assume is past the point it fails for you). I'm having the most aweful
luck with reproduction the past few weeks..


