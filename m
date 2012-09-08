Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2IHWas (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 18:30:48 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:28456 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375Ab2IHWaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 18:30:46 -0400
Date: Sat, 8 Sep 2012 22:30:45 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ezequiel Garcia <elezegarcia@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, JoonSoo Kim <js1304@gmail.com>,
        Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <rostedt@goodmis.org>,
        David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v2 0/10] mm: SLxB cleaning and trace accuracy
 improvement
In-Reply-To: <CALF0-+VMtUPuLHg3CwDxFm-TjbN1=YavGO79Oo3GuymOLvikeA@mail.gmail.com>
Message-ID: <00000139a801aba3-4616277c-d845-4b62-83ec-1a1950b05751-000000@email.amazonses.com>
References: <CALF0-+VMtUPuLHg3CwDxFm-TjbN1=YavGO79Oo3GuymOLvikeA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Sep 2012, Ezequiel Garcia wrote:

> This is the second spin of my patchset to clean SLxB and improve kmem
> trace events accuracy.

Please redo the patches on top of the patchsets that create
mm/slab_common.c. You will be able to extract a lot more common code and
help the goal of having as much common code as possible. PLease move as
much as possible of the common functions into slab_common.c

