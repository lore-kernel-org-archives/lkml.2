Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1FJQ12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 12:27:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:39412 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab1FJQ10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 12:27:26 -0400
Subject: Re: BUG on 3.0-rc on commit
 d72bce0e67e8afc6eb959f656013cbb577426f1e
From: Peter Zijlstra <peterz@infradead.org>
To: habanero@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, rostedt <rostedt@goodmis.org>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1307720081.17297.6.camel@atheurer-w510>
References: <1307711837.23688.33.camel@atheurer-ubuntu10>
	 <1307715084.3941.166.camel@twins>  <1307717156.3941.169.camel@twins>
	 <1307720081.17297.6.camel@atheurer-w510>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Jun 2011 18:27:12 +0200
Message-ID: <1307723232.3941.178.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 10:34 -0500, Andrew Theurer wrote:
> RIP: 0010:[<ffffffff8104e8c1>]  [<ffffffff8104e8c1>] find_lowest_rq+0xa1/0x150

If you've still got the vmlinux around, could you find out where in
find_lowest_rq that RIP is? 
