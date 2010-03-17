Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab0CQKoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:44:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:30000 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab0CQKoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:44:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject;
        b=rBjwwSkFU3jYoe2ePm0/gI+N7OkPLrQqD5JRdVa8YsDUXkykMfe3wJs/+c4cmebq2u
         OvaAfPekIPnuY8V0Vu59tKkbO05HA0lde8vNCZzGo+QBgBhVwwXZ15Vs6xde5z1ulwFM
         uM9sFQKu/7syRmrF3W466wPJMoS3OcEP/A6Qg=
Message-Id: <20100317103659.717877821@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 17 Mar 2010 13:36:59 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org
Subject: [patch 0/2] x86, apic, perf - make apic_write/read noop on !APIC case
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allow us to save some #ifdef's.
Please review.

Cyrill
