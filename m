Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab2BJRsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:48:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759332Ab2BJRsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:48:07 -0500
Message-ID: <4F355850.5050403@redhat.com>
Date: Fri, 10 Feb 2012 17:48:00 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Denys Vlasenko <vda.linux@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org, Chris Evans <scarybeasts@gmail.com>,
        Indan Zupancic <indan@nul.nu>
Subject: Re: [PATCH 0/2] more tweaks (Was: ptrace tweaks)
References: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com> <20120210173237.GF8908@redhat.com>
In-Reply-To: <20120210173237.GF8908@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yay, new bike shed!  ;-)

On 02/10/2012 05:32 PM, Oleg Nesterov wrote:

> Chris, iirc you suggested to add PTRACE_O_KILL_TRACEE_IF_DEBUGGER_DIES.
> The necessary change is simple, please suggest the good name for the
> new option ;)

PTRACE_O_KILL_ON_EXIT .  Cause Windows has had DebugSetProcessKillOnExit(bool) for ages.

-- 
Pedro Alves
