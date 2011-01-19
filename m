Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1ASEge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 23:36:34 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51845 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1ASEgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 23:36:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=juuTtaniVQLrSjZf1wWGdqCLYFV09iY18vz4aHJR+S3N+/AKxAL4gegIUdkARP6G9w
         AenIqOS5v7rkBsXV8Rl/68+K/7+aLMQv1/g6VMHaN8j9JML9ChrRdGY4XsdpaeXYhCdd
         IHO/Ceb8yH+MBG77H82S7Yx0Pgny7179rpbxQ=
Date: Wed, 19 Jan 2011 12:36:05 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Tony Finch <dot@dotat.at>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] unifdef: update to upstream version 2.5
Message-ID: <20110119043605.GA9903@cr0.nay.redhat.com>
References: <E1PfI64-00041z-0d@hermes-1.csi.cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1PfI64-00041z-0d@hermes-1.csi.cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 08:12:49PM +0000, Tony Finch wrote:
>Fix a long-standing cpp compatibility bug. The -DFOO argument
>(without an explicit value) should define FOO to 1 not to the empty
>string.
>
>Add a -o option to support overwriting a file in place, and a -S
>option to list the nesting depth of symbols. Include line numbers
>in debugging output. Support CRLF newlines.
>

Could you split the patch? It is hard for review.

Thanks!
