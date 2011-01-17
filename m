Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab1AQVJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 16:09:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60390
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439Ab1AQVJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 16:09:43 -0500
Date: Mon, 17 Jan 2011 13:10:16 -0800 (PST)
Message-Id: <20110117.131016.70199236.davem@davemloft.net>
To: casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, xemul@openvz.org,
        ext-jarkko.2.sakkinen@nokia.com, Janne.Karhunen@nokia.com,
        elena.reshetova@nokia.com
Subject: Re: [PATCH] scm: provide full privilege set via SCM_PRIVILEGE
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D3466BD.10500@schaufler-ca.com>
References: <4D3466BD.10500@schaufler-ca.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Networking patches need to be CC:'d to netdev@vger.kernel.org,
not me.

