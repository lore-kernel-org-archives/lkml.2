Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833Ab0FQWi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 18:38:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36731 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab0FQWiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 18:38:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:sender:date:x-google-sender-auth:message-id:
	subject:from:to:cc:content-type:x-system-of-record;
	b=oMQqB1EhKKG1XMUVK6iAUy0finrv6WHySOY8DerpwmYYfakYIT23jcoE++kBrD+8C
	CoPPoCZ6/tgWQ6GtkgY7A==
MIME-Version: 1.0
Date: Thu, 17 Jun 2010 15:38:19 -0700
X-Google-Sender-Auth: gAECv94qDkMmHf6dS6T7vVpnjSw
Message-ID: <AANLkTikXH_UtE95ZGHp5AAm5IRD6dN8cnrNK9A3-MRwY@mail.gmail.com>
Subject: [GIT PULL linux-next] tegra
From: Erik Gilling <konkers@android.com>
To: sfr@canb.auug.org.au
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

Can you please pull the following into linux-next?

git://android.git.kernel.org/kernel/tegra.git for-next

This tree adds support for the Nvidia Tegra ARM SOCs.  It's received
review on linux-arm-kernel.

Thanks,
    Erik Gilling
