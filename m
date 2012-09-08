Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2IHQYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 12:24:22 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61545 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2IHQYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 12:24:21 -0400
MIME-Version: 1.0
In-Reply-To: <1347116812-93646-1-git-send-email-dsahern@gmail.com>
References: <1347116812-93646-1-git-send-email-dsahern@gmail.com>
Date: Sat, 8 Sep 2012 19:24:20 +0300
X-Google-Sender-Auth: n-RDiKDv2oSTMGNazRMgQ0KAu4c
Message-ID: <CAOJsxLFv=LkYi5WBSNxgc3ejScV0KOMN=fHw2+8A8SRkyWL32g@mail.gmail.com>
Subject: Re: [PATCH 0/3] perf tool: basename cleanups
From: Pekka Enberg <penberg@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        irina.tirdea@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 8, 2012 at 6:06 PM, David Ahern <dsahern@gmail.com> wrote:
> basename can modify strings passed to it, so the strings should not
> be marked const. Clean up the offenders and remove the BIONIC wrapper
> for libgen.h
>
> Irina: Would you verify perf still compiles cleanly for Android. Thanks.

To all three patches:

Acked-by: Pekka Enberg <penberg@kernel.org>
