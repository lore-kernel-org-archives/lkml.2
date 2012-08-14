Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2HNIfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:35:42 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:21551 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571Ab2HNIfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:35:39 -0400
Message-ID: <502A0DC4.8090106@parallels.com>
Date: Tue, 14 Aug 2012 12:35:16 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        Andrew Vagin <avagin@openvz.org>
Subject: Re: [PATCH 13/21] userns: Teach inet_diag to work with user namespaces
References: <87ehnav9n5.fsf@xmission.com> <1344889115-21610-1-git-send-email-ebiederm@xmission.com> <1344889115-21610-13-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1344889115-21610-13-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 12:18 AM, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Compute the user namespace of the socket that we are replying to
> and translate the kuids of reported sockets into that user namespace.
> 
> Cc: Andrew Vagin <avagin@openvz.org>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Pavel Emelyanov <xemul@parallels.com>
