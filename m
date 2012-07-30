Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab2G3Q7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 12:59:42 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:46787 "EHLO
	homiemail-a47.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754158Ab2G3Q7l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 12:59:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=subject:from
	:content-type:message-id:date:to:content-transfer-encoding:
	mime-version; q=dns; s=shealevy.com; b=Ohzzd5lCn5cPpc0RHDb7tO9Cp
	D/8dEZYjPGwPSRdx7cKDrxvJ2Q3fRYbahTQUVvfvZwWP2XNX5IJJ71LMAn8C9aug
	Ssjlx3J9gQhkXwcCdCDqKewA27P4ZOYzguPCi3YrttnCkD5Jn9PR92MJwLDvONpV
	YSHEOGo5vP6gZSyeDA=
Subject: Alternative to vfork(2) with overcommit off
From: Shea Levy <shea@shealevy.com>
Content-Type: text/plain;
	charset=us-ascii
X-Mailer: iPad Mail (9B206)
Message-Id: <EC19EF84-3DD4-4B5A-9469-2EC11EE089D6@shealevy.com>
Date: Mon, 30 Jul 2012 12:59:42 -0400
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (1.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The vfork(2) manpage states "It is rather unfortunate that Linux revived this specter from the past", but on systems with overcommit turned off fork(2) can be needlessly prohibitive when the goal is to execve(2) right away. Is there a third alternative for the fork/execve case? If not, should the manpage really be so dismissive of vfork?

Cheers,
Shea Levy