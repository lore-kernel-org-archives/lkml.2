Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab0KKEWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 23:22:49 -0500
Received: from tundra.namei.org ([65.99.196.166]:51719 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310Ab0KKEWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 23:22:48 -0500
Date: Thu, 11 Nov 2010 15:22:36 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Dan Rosenberg <drosenberg@vsecurity.com>
cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, kees.cook@canonical.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v3] Restrict unprivileged access to kernel syslog
In-Reply-To: <1289431735.3847.9.camel@dan>
Message-ID: <alpine.LRH.2.00.1011111519240.20978@tundra.namei.org>
References: <1289431735.3847.9.camel@dan>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, security@kernel.org is for security response, not for submitting 
security features.

Please cc the LSM list for security feature development.

i.e. linux-security-module@vger.kernel.org


- James
-- 
James Morris
<jmorris@namei.org>
