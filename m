Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab0KAJZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 05:25:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60447 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab0KAJZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 05:25:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tBqBd6B+4cZom9/qm8wQ17zt7hn0XV7vn3Lj+S7CxCwY4FFJD2Am9+U+UJndoc1W7y
         gOjukxzKJl84owoLw57iuDPXoNv/hqtbbyPtB8kfGzsQ4NvDP0JjV478BGvtEfZTun2F
         7RfhRXPyB24IMFj++DiEikSWPOgiZcUkXEV94=
Date: Mon, 1 Nov 2010 17:29:47 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: tingwei liu <tingw.liu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How many params can be accept by kernel module at most?
Message-ID: <20101101092947.GB6023@cr0.nay.redhat.com>
References: <AANLkTikfW7QfXX76JM=pDYuQYexPvQz3hrAE=B3YMD5x@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikfW7QfXX76JM=pDYuQYexPvQz3hrAE=B3YMD5x@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 02:17:23PM +0800, tingwei liu wrote:
>How many params can be accept by kernel module at most?

If you mean dynamically, these parameters are passed as a whole to kernel,
from the source code, you can see the max length is ~0UL>>1.

If you mean statically, IOW, the max paramenters you can provide in your module,
this is limited by ELF section size.

Hope this helps.
