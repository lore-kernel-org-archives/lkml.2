Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936Ab1ECHLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 03:11:06 -0400
Received: from narfation.org ([79.140.41.39]:52540 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab1ECHLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 03:11:05 -0400
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 03:11:05 EDT
From: Sven Eckelmann <sven@narfation.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH tip/core/rcu 5/7] batman,rcu: convert call_rcu(softif_neigh_free_rcu) to kfree_rcu
Date: Tue, 3 May 2011 09:02:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38-2-686; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
References: <20110502161321.GA6537@linux.vnet.ibm.com> <1304352824-6563-5-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1304352824-6563-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2456045.IMDECmqdMY";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201105030902.55733.sven@narfation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2456045.IMDECmqdMY
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Monday 02 May 2011 18:13:42 Paul E. McKenney wrote:
> The RCU callback softif_neigh_free_rcu() just calls kfree(), so we can
> use kfree_rcu() instead of call_rcu().
>=20
[...]
> The RCU callback neigh_node_free_rcu() just calls kfree(), so we can use
> kfree_rcu() instead of call_rcu().
[...]
> The RCU callback gw_node_free_rcu() just calls kfree(), so we can use
> kfree_rcu() instead of call_rcu().

Thanks, I am fine with Patch 3/7, 4/7, 5/7.

Acked-by: Sven Eckelmann <sven@narfation.org>

--nextPart2456045.IMDECmqdMY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJNv6icAAoJEF2HCgfBJntGDLYP/0EwYgGQPUZJmEWdNJEgTKJW
TFcI95LcGzXKkwGkszMXPRvucorZUemYdiu3ylAzy4VGHslCTBQ4GfybXsDhUREV
H+eOzwJ8Yrt5NHUtg6RHyP1Vn8wYsSWA+i1aV1cfsmwpAqRScdPu8WG0+uVYKLNn
zk45HQTvVzjZMpmSCEMwxn8mGxh6GNGKzbRlQaNFzDckiOVJjqeyh6XxUv4uTfnO
DxORUoZvL/FmNsMrfGb1DH6DeCRVHlGrmXeaN/44qWvT0PYKVv14WIRJtMPcQQil
+7koqG2bvbtF9meRvVgaDVVhPEQ4bwzEzocUULnB9ucr3dyqk9hNkk/QwJ7Wa8A7
6n4i2Fc4dDvvD+7jqhbZ+4SWzX3cGCMUHv21IJCN+sf/nkwgY5CBR8UM17pFJqAk
WQSZtcQTTqrVwnbnjju3PIPVCpr72BNAReXi+V+CdGuXO2kWZPEHIrH1HCvJ5qVa
zFWeUaMo61YpkTeJuLW20kuSDTx7WWr9dzR/0KrhUXrsowhaV4R/YAFft9xjNjE/
OWMQRLRro3+DSSeNvn12DFe9a8EtcWS5g+e/Snsg0MkkvZ7kTKqlruIQO/VNQKLV
fRatHU2IKOej7YFBpR2FoWUiWQuW4gEQ6hbGYUaq0O6IY5y6/+R79893R53TLMyZ
00MlRxgOYI4bunz9A8KY
=zh0v
-----END PGP SIGNATURE-----

--nextPart2456045.IMDECmqdMY--
