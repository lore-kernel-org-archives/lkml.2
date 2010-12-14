Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab0LNKyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:54:13 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:42786 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab0LNKyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:54:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tzJdFGUuPt++tPE01bzXMfR0yEatidsL8q4AO3o8o8d/F2074ObQpSTy7PEllHI2Y5
         abxJ7/Nx7A04Ii4JyfhFkT2WMZc/YGdfifEGHGLxItg0zTxTkcqN+Mu3u0kbGEqcOQVm
         KQC/4HwAeSu3LC7GPyMhEYIRZA2yKgYmEFM/o=
Date: Tue, 14 Dec 2010 12:54:05 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [Patch 0/21] Non disruptive application core dump
 infrastructure
Message-ID: <20101214105405.GB4834@core2.telecom.by>
References: <20101214152259.67896960@suzukikp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214152259.67896960@suzukikp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 03:22:59PM +0530, Suzuki K. Poulose wrote:
> The interface is provided by a /proc/pid/core file, reading which can give the 

What happens when process opens /proc/self/core ?
What happens when process opens /proc/self/core and coredumps before close(2).
