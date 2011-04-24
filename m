Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab1DXHMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 03:12:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936Ab1DXHMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 03:12:42 -0400
Message-ID: <4DB3CD5E.4000507@redhat.com>
Date: Sun, 24 Apr 2011 10:12:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH -next] kvm: fix const value warning on i386
References: <20110421132045.5af1b953.sfr@canb.auug.org.au> <20110421090922.4d9a275b.randy.dunlap@oracle.com>
In-Reply-To: <20110421090922.4d9a275b.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2011 07:09 PM, Randy Dunlap wrote:
> From: Randy Dunlap<randy.dunlap@oracle.com>
>
> arch/x86/kvm/emulate.c:2598: warning: integer constant is too large for 'long' type

Applied, thanks.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

