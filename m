Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab0LBCpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:45:44 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35925 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab0LBCpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:45:43 -0500
Subject: Re: [PATCH] media: rc: lirc_dev: check kobject_set_name() result
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <1290791203-21448-1-git-send-email-segoon@openwall.com>
Date: Wed, 1 Dec 2010 21:45:39 -0500
Cc: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3F92DE6F-9421-4AE3-B5DB-C69567A95D09@wilsonet.com>
References: <1290791203-21448-1-git-send-email-segoon@openwall.com>
To: Vasiliy Kulikov <segoon@openwall.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 26, 2010, at 12:06 PM, Vasiliy Kulikov wrote:

> kobject_set_name() may fail with -ENOMEM, check for it.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
> Compile tested only.

Works for me.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com



