Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1AQHAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 02:00:12 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45415 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab1AQHAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 02:00:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mT2B5695l2U8IInGt2oncXgbOC4Ve1EjuR7cSNU2zDI8lZIsngg+fzaMOcZSDNMd0c
         4gELSJJKHCfVjr+NeM9jQ68UYQdD0OCbXak3hm0muonrq0j2h8QNa6Jd8o0D8bnSELBb
         7uWWsQHG2HTibQlt4pnQMkqm68otGkCd30zEE=
Date: Mon, 17 Jan 2011 15:00:00 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: xing lin <linxingnku@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request at ffff8800cf669000
Message-ID: <20110117070000.GE11358@cr0.nay.redhat.com>
References: <AANLkTin9dGAQ1fZM_8MsFr3dGwc17vGEGszY_hPMdozp@mail.gmail.com>
 <AANLkTimgYxjJwF+kORC6Z9vJMLwGvQVv85PkGPRCzyvK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimgYxjJwF+kORC6Z9vJMLwGvQVv85PkGPRCzyvK@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 04:03:59PM -0700, xing lin wrote:
>It turns out I can not read that page in a kernel module at all. A
>simple read of that page will result in an oops as well. I have
>checked the flags of this page with others. They are almost the same.
>Any suggestions about why this happens or how to know whether a page
>can be read or not are really welcome. Thanks.
>

If you are using x86, you have CONFIG_X86_PTDUMP, with which
you can dump all page tables via debugfs.

Hope this helps.
