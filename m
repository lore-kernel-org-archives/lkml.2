Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab0JHOZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:25:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42180 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab0JHOZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:25:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FMO+jMvpHISGAWBp13cpjl1GESXSkj+iUKR3/CraSLvmzrBw+A8MYbcuqtFjugzlFo
         10vDX+2eW8F4Zh0R0hMSja1WF33lBNrxXPctCiVqyklIw2GAjKcnYVKOaWAEjfF57syf
         XG4CqHemCKUMDJ3UJT+CXp4p+bvCeE5RKjbaU=
Date: Fri, 8 Oct 2010 22:27:52 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: khaled MOHAMMED atteya <khaled.m.atteya@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ask about include header file
Message-ID: <20101008142752.GE4088@hack>
References: <AANLkTikUoNwzHNyuWNGgJ6QkMNbbyTG7SmMQqZaR1E9_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikUoNwzHNyuWNGgJ6QkMNbbyTG7SmMQqZaR1E9_@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 08:25:09PM -0200, khaled MOHAMMED atteya wrote:
>In arch/x86/kernel/entry_32.S(for example) , audit_syscall_entry
>function is called by this statement "call audit_syscall_entry", and
>when i search about this function declaration , i found it in
>include/linux/audit.h , but i couldn't found #include linux/audit.h in
>entry_32.S as i expected, why?
>

Hey,

that is asm, not C, asm doesn't need declarations, C does. :)

-- 
Live like a child, think like the god.
 
