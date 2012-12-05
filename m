Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab2LENk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 08:40:27 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49125 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab2LENkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 08:40:24 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 3/4] sta2x11_vip: convert to videobuf2 and control framework
Date: Wed, 05 Dec 2012 14:45:01 +0100
Message-ID: <7613127.WGiHT7h3dc@harkonnen>
User-Agent: KMail/4.9.3 (Linux/3.6.8-2.fc17.x86_64; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50BF4E25.3010207@redhat.com>
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com> <1773237.zC2M0dmkYp@harkonnen> <50BF4E25.3010207@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not sure if you got my point: the main point of removing MODULE_AUTHOR
> and other copyright stuff is that such patch may easily be doing something
> that could be considered a copyright violation, being bad not only to
> the affected driver, but to the entire Kernel.
> 
> So, we need to handle it with due care. Getting other authors's
> acks on such patch seems to be the only safe way of doing that.

Yes I got the point.

Thank you

-- 
Federico Vaga
