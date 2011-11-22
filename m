Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1KVOLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:11:35 -0500
Received: from mail176c2.megamailservers.com ([69.49.111.76]:57458 "EHLO
	mail176c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995Ab1KVOLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:11:34 -0500
X-Authenticated-User: konrad.gaisler.com
From: Konrad Eisele <konrad@gaisler.com>
To: linux-kernel@vger.kernel.org
Cc: lacombar@gmail.com, mmarek@suse.cz, yann.morin.1998@anciens.enib.fr,
        linux-config@vger.kernel.org, konrad@gaisler.com
Subject: [PATCH 0/3] intro
Date: Tue, 22 Nov 2011 15:03:43 +0100
Message-Id: <1321970626-12615-1-git-send-email-konrad@gaisler.com>
X-Mailer: git-send-email 1.6.4.1
In-Reply-To: <CACqU3MXPWvfThDmLMrK+ne+_hDXOU=atJpC98hUHL04DXUPAxw@mail.gmail.com>
References: <CACqU3MXPWvfThDmLMrK+ne+_hDXOU=atJpC98hUHL04DXUPAxw@mail.gmail.com>
X-CSC: 0
X-CHA: v=1.1 cv=vjffymXyDtjo34N5cbiAavWp8ckkCSHNaVzdIDazEXU= c=1 sm=1
		a=U62ajLuCel8A:10 a=jXKJviUpWSOlMmIvGrHOfw==:17 a=ckWJXcBQ1zXHuCH2F68A:9
		a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/3] kconfig: Move global elements into struct, create root context
  remove globals and create seperate namespaces. The default namespace is
  &rootlevel.

[PATCH 2/3] kconfig: Add support for Kconfig subtrees
  This adds subtree support, added Documentation/kbuild/kconfig-language.txt
  lines that describe the fix

[PATCH 3/3] kconfig: gconfig save button should be greyed if no changes present
  in gconfig the save button is always active eaven with no changes present.
