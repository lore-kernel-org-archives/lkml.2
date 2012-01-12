Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2ALGoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 01:44:54 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:45317 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751906Ab2ALGow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 01:44:52 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1201120842140.2054@tux.localdomain>
References: <1326300636-29233-1-git-send-email-levinsasha928@gmail.com>
	<alpine.DEB.2.00.1201111346180.21755@chino.kir.corp.google.com>
	<alpine.LFD.2.02.1201120842140.2054@tux.localdomain>
Date: Thu, 12 Jan 2012 08:44:51 +0200
X-Google-Sender-Auth: NzYzhHhb4hWLcZanzvEAKYdpuHw
Message-ID: <CAOJsxLGTO8=w8nYADY9hVBs_63UGR-jfrPOYsgexDUo-pPFjDQ@mail.gmail.com>
Subject: Re: [PATCH] mm: Don't warn if memdup_user fails
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, lizf@cn.fujitsu.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 8:43 AM, Pekka Enberg <penberg@kernel.org> wrote:
> Sasha, I suppose strndup_user() has the same kind of issue?

Oh, it uses memdup_user() internally. Sorry for the noise.
