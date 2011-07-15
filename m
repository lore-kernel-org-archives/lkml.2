Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965392Ab1GOKEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 06:04:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51367 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965286Ab1GOKEn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 06:04:43 -0400
MIME-Version: 1.0
In-Reply-To: <07ef9de13b16d5c50bc36f8c8d9a9aa28a05f2ca.1310657068.git.jbaron@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com> <07ef9de13b16d5c50bc36f8c8d9a9aa28a05f2ca.1310657068.git.jbaron@redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 15 Jul 2011 12:04:22 +0200
X-Google-Sender-Auth: gzHZ6UNyySXlw3ohLthHuR69024
Message-ID: <CAO+b5-qQ452VojorX_p4W2orh4DKnM206TA3F5yA2fnhcPhXsQ@mail.gmail.com>
Subject: Re: [PATCH 03/11] dynamic_debug: Remove uses of KERN_CONT in dynamic_emit_prefix
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, joe@perches.com, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 6:09 PM, Jason Baron <jbaron@redhat.com> wrote:
> +       char tid[sizeof(int) + sizeof(int)/2 + 4];
> +       char lineno[sizeof(int) + sizeof(int)/2];

It's not clear to me where the array bounds come from ? Also, why
sizeof(int) + sizeof(int)/2 instead of sizeof(int)*3 + 1 ?

Bart.
