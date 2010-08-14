Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934714Ab0HNKmN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 06:42:13 -0400
Received: from psw.ro ([94.62.132.84]:39347 "EHLO psw.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454Ab0HNKmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 06:42:08 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Aug 2010 06:42:08 EDT
DomainKey-Signature: a=rsa-sha1; h=Received:DKIM-Signature:X-Virus-Scanned:Received:Received:Received:MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:Organization:In-Reply-To:References:Message-ID:X-Sender:User-Agent; b=YNW8zsf0DWYFGkqyzaKgUYd+PaCayTUZNS1aBuvXFIwO9RUhAlDvP2G+ChwWYeg/Ix2A3Z4JjziFUHTbdUensH+FesxhV3XWSvdO0nUthT8LSP6V54m0KlL5BQILbe69OiapiKjqGla3F6SaYj1W5M3cWqQu+WpInFkrvCoTfS8=; c=nofws; d=psw.ro; q=dns; s=mail
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Sat, 14 Aug 2010 13:35:16 +0300
From: Arthur Titeica <arthur@psw.ro>
To: Greg KH <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, <stable@kernel.org>, <lwn@lwn.net>
Subject: Re: Linux 2.6.35.2
Organization: PharmEc Software
In-Reply-To: <20100813212313.GA22102@kroah.com>
References: <20100813212313.GA22102@kroah.com>
Message-ID: <a00737cba20cb46512a2248e0477cc0b@linux.psw.ro>
User-Agent: Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Aug 2010 14:23:13 -0700, Greg KH <gregkh@suse.de> wrote:
> I'm announcing the release of the 2.6.35.2 kernel.
> 
> All users of the 2.6.35 kernel series must upgrade.
> 

I'm not sure this is the right mailing list but this is the first
kernel that fails to boot for me (since 2.6.33.x).

The laptop just restarts right after "Freeing unused kernel memory:
628k freed"

2.6.35.1 is fine with the same .config.

Anyone willing to help me to debug?

-- 
Arthur Titeica

