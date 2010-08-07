Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762446Ab0HGDZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 23:25:46 -0400
Received: from mail.lang.hm ([64.81.33.126]:56711 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab0HGDZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 23:25:43 -0400
Date: Fri, 6 Aug 2010 20:25:43 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: KCONFIG savedefconfig
Message-ID: <alpine.DEB.2.00.1008062024320.30564@asgard.lang.hm>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when savedefconfig decides what to write out, what does it do for things 
that are not at the default, but were set to not be default as part of 
dependancy resolution?

David Lang
